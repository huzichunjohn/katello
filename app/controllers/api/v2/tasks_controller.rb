#
# Copyright 2013 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

class Api::V2::TasksController < Api::V2::ApiController

  before_filter :find_organization, :only => [:index]
  before_filter :find_task, :only => [:show]
  before_filter :authorize

  def rules
    # tasks are used in: synchronization, promotion, packages updating, organizatino deletion
    test = lambda do
      # at the end of organization deletion, there is no organization, so we
      # check if the user has the rights to see the task.
      if @task && User.current == @task.user
        true
      elsif @organization
        Provider.any_readable?(@organization) || @organization.systems_readable?
      else
        false
      end
    end
    {
      :index => test,
      :show  => test,
    }
  end

  api :GET, "/organizations/:organization_id/tasks", "List tasks of given organization"
  param :organization_id, :identifier, :desc => "organization identifier", :required => true
  def index
    respond :collection => TaskStatus.where(:organization_id => @organization.id)
  end

  api :GET, "/tasks/:id", "Show a task info"
  param :id, :identifier, :desc => "task identifier", :required => true
  def show
    @task.refresh
    respond_for_show
  end

  private

  def find_task
    @task         = TaskStatus.find_by_id!(params[:id])
    @organization = @task.organization
  end

  private

  def find_task
    @task = TaskStatus.find_by_id!(params[:id])
    @organization = @task.organization
  end

end
