import { application } from "./application"

import ExistingGameController from "./existing_game_controller"
import ModalController from "./modal_controller"
import NotificationController from "./notification_controller"
import TomSelectController from "./tom_select_controller"

application.register("existing-game", ExistingGameController)
application.register("modal", ModalController)
application.register("notification", NotificationController)
application.register("tom-select", TomSelectController)
