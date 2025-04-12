import { application } from "./application"
import TextareaAutogrowController from "./textarea_autogrow_controller"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

application.register("textarea-autogrow", TextareaAutogrowController)