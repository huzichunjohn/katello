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

class Api::V1::CandlepinProxiesController < Api::V1::ProxiesController

  # authorization rules are implemented in proxies_controller.rb

  def get
    r = ::Resources::Candlepin::Proxy.get(@request_path)
    logger.debug r
    render :json => r
  end

  def delete
    r = ::Resources::Candlepin::Proxy.delete(@request_path)
    logger.debug r
    render :json => r
  end

  def post
    r = ::Resources::Candlepin::Proxy.post(@request_path, @request_body)
    logger.debug r
    render :json => r
  end

  private

  def logger
    ::Logging.logger['cp_proxy']
  end

end
