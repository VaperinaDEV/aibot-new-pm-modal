import Component from "@glimmer/component";
import { service } from "@ember/service";
import { action } from "@ember/object";
import concatClass from "discourse/helpers/concat-class";
import DButton from "discourse/components/d-button";
import AiBotModal from "./modal/aibot-modal";
import i18n from "discourse-common/helpers/i18n";

export default class SidebarAiBotButton extends Component {
  @service modal;
  
  @action
  openAiBotModal() {
    this.modal.show(AiBotModal);
  }

  <template>
    <DButton
      @action={{this.openAiBotModal}}
      @translatedLabel={{i18n (themePrefix "new_question")}}
      @icon={{settings.sidebar_aibot_button_before_icon}}
      class={{concatClass
        "ai-new-question-button"
        settings.sibebar_aibot_button_style
      }}
    />
  </template>
}
