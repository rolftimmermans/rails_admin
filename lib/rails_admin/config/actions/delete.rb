module RailsAdmin
  module Config
    module Actions
      class Delete < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        
        register_instance_option :object_level do
          true
        end
        
        register_instance_option :route_fragment do
          'delete'
        end
        
        register_instance_option :http_methods do
          [:get, :delete]
        end

        register_instance_option :authorization_key do
          :destroy
        end
        
        register_instance_option :controller do
          Proc.new do
            if request.get? # DELETE
            
              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, :layout => false }
              end
            
            elsif request.delete? # DESTROY
              
              @auditing_adapter && @auditing_adapter.delete_object("Destroyed #{@model_config.with(:object => @object).object_label}", @object, @abstract_model, _current_user)
              if @abstract_model.destroy(@object)
                flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.delete.done"))
              else
                flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.delete.done"))
              end

              redirect_to back_or_index
              
            end
            
          end
        end
      end
    end
  end
end
