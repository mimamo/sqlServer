USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_Location]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_Location]  @siteid varchar(10), @invtid varchar(30),@whseloc varchar(10)  as      
select * from Location where 
siteid = @siteid 
and invtid = @invtid
and whseloc = @whseloc
order by siteid
GO
