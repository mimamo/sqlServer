USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_Location]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_Location]   @invtid varchar(30),@siteid varchar(10) , @whseloc varchar(10)  as      
select * from Location where 
invtid = @invtid
and  siteid = @siteid
and whseloc = @whseloc
order by invtid
GO
