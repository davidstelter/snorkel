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

    cond_string  = []
    cond_hash    = {}
    participants = {}

  
    if params[:sig_name] && params[:sig_name].length > 0
      cond_string << "sig_name ILIKE :name"
      cond_hash[:name] = "%#{params[:sig_name]}%"
    end

    if params[:pri] && params[:pri].length > 0
      cond_string << "sig_priority = :pri"
      cond_hash[:pri] = "#{params[:pri]}"
    end

    if params[:min_cnt] && params[:min_cnt].length > 0
      cond_string << "event_count >= :min_cnt"
      cond_hash[:min_cnt] = "#{params[:min_cnt]}"
    end

    if params[:max_cnt] && params[:max_cnt].length > 0
      cond_string << "event_count <= :max_cnt"
      cond_hash[:max_cnt] = "#{params[:max_cnt]}"
    end

    if params[:ip_src] && params[:ip_src].length > 0
      participants.merge!({:ip_src => params[:ip_src]})
    end  

    if params[:ip_dst] && params[:ip_dst].length > 0
      participants.merge!({:ip_dst => params[:ip_dst]})
    end  

    conditions = cond_string.join(" AND ")


    @signatures = Signature.with_participants(participants).find(:all, 
                                      :limit      => @summary_pager.per_page,
                                      :offset     => @summary_pager.offset, 
                                      :order      => order,
                                      :conditions => [ conditions, cond_hash])
  end

  def detail 
    @order     = params[:order] || 'timestamp'
    @signature = Signature.find(params[:id])
    @pager     = Pager.new(@signature.alerts.count, params[:page])
    @alerts    = @signature.alerts.find(:all, 
                                        :limit  => @pager.per_page,
                                        :offset => @pager.offset,
                                        :order  => @order)
  end

end
