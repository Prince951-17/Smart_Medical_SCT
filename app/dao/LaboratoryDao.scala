package dao

import akka.actor.ActorSystem
import com.google.inject.ImplementedBy
import com.typesafe.scalalogging.LazyLogging
import javax.inject.{Inject, Singleton}
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import protocols.RegistrationProtocol.Laboratory
import slick.jdbc.JdbcProfile
import utils.Date2SqlDate

import scala.concurrent.{ExecutionContext, Future}


trait LaboratoryComponent {
  self: HasDatabaseConfigProvider[JdbcProfile] =>

  import utils.PostgresDriver.api._

  class LaboratoryTable(tag: Tag) extends Table[Laboratory](tag, "Laboratory") with Date2SqlDate {
    def id = column[Int]("id", O.PrimaryKey, O.AutoInc)

    def laboratoryName = column[String]("laboratory_name")

    def * = (id.?, laboratoryName) <> (Laboratory.tupled, Laboratory.unapply _)
  }

}

@ImplementedBy(classOf[LaboratoryDaoImpl])
trait LaboratoryDao {

  def addLaboratory(data: Laboratory): Future[Int]

}

@Singleton
class LaboratoryDaoImpl @Inject()(protected val dbConfigProvider: DatabaseConfigProvider,
                               val actorSystem: ActorSystem)
                              (implicit val ec: ExecutionContext)
  extends LaboratoryDao
    with LaboratoryComponent
    with HasDatabaseConfigProvider[JdbcProfile]
    with Date2SqlDate
    with LazyLogging {

  import utils.PostgresDriver.api._

  val laboratorysTable = TableQuery[LaboratoryTable]

  override def addLaboratory(data: Laboratory): Future[Int] = {
    db.run {
      logger.warn(s"daoga keldi: $data")
      (laboratorysTable returning laboratorysTable.map(_.id)) += data
    }
  }

}

