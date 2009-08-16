# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class SignaturesController < ApplicationController
  include ControllerCommon
  
  def summary
    if params[:order]
      order = params[:order]
    elsif params[:order_desc]
      order = params[:order_desc]
      order += ' DESC'
    else
      params[:order_desc] = 'event_count'
      order = 'event_count DESC'
    end

    @summary_pager = Pager.new(Signature.count, params[:page])

    cond_string  = []
    cond_hash    = {}
    participants = {}

  
    if pset params[:sig_name]
      cond_string << "sig_name ILIKE :name"
      cond_hash[:name] = "%#{params[:sig_name]}%"
    end

    if pset params[:pri]
      cond_string << "sig_priority = :pri"
      cond_hash[:pri] = "#{params[:pri]}"
    end

    if pset params[:min_cnt]
      cond_string << "event_count >= :min_cnt"
      cond_hash[:min_cnt] = "#{params[:min_cnt]}"
    end

    if pset params[:max_cnt]
      cond_string << "event_count <= :max_cnt"
      cond_hash[:max_cnt] = "#{params[:max_cnt]}"
    end

    if pset params[:ip_src]
      participants[:ip_src] = params[:ip_src]
      if pset params[:ip_src_mask]
        participants[:ip_src_mask] = params[:ip_src_mask]
      end
    end  

    if pset params[:ip_dst]
      participants[:ip_dst] = params[:ip_dst]
      if pset params[:ip_dst_mask]
        participants[:ip_dst_mask] = params[:ip_dst_mask]
      end
    end  

    conditions = cond_string.join(" AND ")


    @signatures = Signature.with_participants(participants).find(:all, 
                                      :limit      => @summary_pager.per_page,
                                      :offset     => @summary_pager.offset, 
                                      :order      => order,
                                      :conditions => [ conditions, cond_hash])
  end

  def detail 
    if params[:order]
      order = params[:order]
    elsif params[:order_desc]
      order = params[:order_desc]
      order += ' DESC'
    else
      params[:order_desc] = 'timestamp'
      order = 'timestamp DESC'
    end
    #@order     = params[:order] || 'timestamp'
    @signature = Signature.find(params[:id])
    session[:selected_sigs] = @signature.sig_id
    @pager     = Pager.new(@signature.alerts.count, params[:page])
    @alerts    = @signature.alerts.find(:all, 
                                        :limit  => @pager.per_page,
                                        :offset => @pager.offset,
                                        :order  => order)
  end

  def delete
    if session[:selected_sigs]
      sigs = Sig.find(session[:selected_sigs])
      sigs.destroy
    end
  end

end
