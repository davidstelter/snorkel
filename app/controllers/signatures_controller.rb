# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class SignaturesController < ApplicationController
  def summary

    if params[:order]
      order = params[:order]
    elsif params[:order_desc]
      order = params[:order_desc]
      order += ' DESC'
    else
      order = 'sig_id'
    end

    @summary_pager = Pager.new(Signature.count, params[:page])
    fh = { :limit  => @summary_pager.per_page,
      :offset => @summary_pager.offset, 
      :order  => order}

    cond_string = []
    cond_hash   = {}
  
 #   if params[:cnt_thresh] && params[:cnt_thresh].length > 0
 #     cond_string << "
    if params[:sig_name] && params[:sig_name].length > 0
      cond_string << "sig_name ILIKE :name"
      cond_hash[:name] = "%#{params[:sig_name]}%"
    end

    if params[:pri] && params[:pri].length > 0
      cond_string << "sig_priority = :pri"
      cond_hash[:pri] = "#{params[:pri]}"
    end

    conditions = cond_string.join(" AND ")


      @signatures    = Signature.find(:all, 
                                      :limit      => @summary_pager.per_page,
                                      :offset     => @summary_pager.offset, 
                                      :order      => order,
                                      :conditions => [ conditions, cond_hash])
  end

  def detail 
    @order     = params[:order] || 'timestamp'
    @signature = Signature.find(params[:id])
    @pager     = Pager.new(@signature.events.count, params[:page])
    @events    = @signature.events.find(:all, 
                                        :limit  => @pager.per_page,
                                        :offset => @pager.offset,
                                        :order  => @order)
  end

end
