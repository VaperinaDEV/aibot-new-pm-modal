import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { action } from "@ember/object";
import { service } from "@ember/service";
import concatClass from "discourse/helpers/concat-class";
import DButton from "discourse/components/d-button";

export default class QuickButtons extends Component {
  @service hiddenSubmit;

  @action
  updateAndSubmit(value) {
    this.hiddenSubmit.inputValue = value;
    this.hiddenSubmit.submitToBot();
  }

  get randomQuickLinks() {
    const shuffledLinks = settings.quick_links.slice().sort(() => Math.random() - 0.5);
    return shuffledLinks.slice(0, 5); // Limit to 5 buttons
  }

  <template>
    <div class="aibot-modal__button-wrapper">
      {{#each this.randomQuickLinks as |link|}}
        <DButton
          @action={{fn this.updateAndSubmit link.question}}
          @translatedLabel={{link.question}}
          class={{concatClass
            "ai-question-button"
            settings.quick_buttons_style
          }}
        />
      {{/each}}
    </div>
  </template>
}
