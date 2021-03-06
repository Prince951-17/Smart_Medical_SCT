package dao

import akka.actor.ActorSystem
import com.google.inject.ImplementedBy
import com.typesafe.scalalogging.LazyLogging
import javax.inject.{Inject, Singleton}
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import protocols.RegistrationProtocol._
import slick.jdbc.JdbcProfile
import utils.Date2SqlDate
import play.api.libs.json.JsValue

import scala.concurrent.{ExecutionContext, Future}


trait CheckupPeriodComponent {
  self: HasDatabaseConfigProvider[JdbcProfile] =>

  import utils.PostgresDriver.api._

  class CheckupPeriodTable(tag: Tag) extends Table[CheckupPeriod](tag, "Checkup_period") with Date2SqlDate {
    def id = column[Int]("id", O.PrimaryKey, O.AutoInc)

    def workTypeId = column[Int]("work_type_id")

    def numberPerYear = column[Int]("number_per_year")

    def docTypeId = column[Int]("doctor_type_id")

    def labTypeId = column[Int]("lab_type_id")

    def specPartJson = column[JsValue]("spec_part_json")

    def * = (id.?, workTypeId, numberPerYear, docTypeId.?, labTypeId.?, specPartJson.?) <> (CheckupPeriod.tupled, CheckupPeriod.unapply _)
  }

}

@ImplementedBy(classOf[CheckupPeriodDaoImpl])
trait CheckupPeriodDao {
  def addCheckupPeriod(data: CheckupPeriod): Future[Int]
}

@Singleton
class CheckupPeriodDaoImpl @Inject()(protected val dbConfigProvider: DatabaseConfigProvider,
                               val actorSystem: ActorSystem)
                              (implicit val ec: ExecutionContext)
  extends CheckupPeriodDao
    with CheckupPeriodComponent
    with HasDatabaseConfigProvider[JdbcProfile]
    with Date2SqlDate
    with LazyLogging {

  import utils.PostgresDriver.api._

  val checkupPeriod = TableQuery[CheckupPeriodTable]

  override def addCheckupPeriod(data: CheckupPeriod): Future[Int] = {
    db.run {
      (checkupPeriod returning checkupPeriod.map(_.id)) += data
    }
  }
}

