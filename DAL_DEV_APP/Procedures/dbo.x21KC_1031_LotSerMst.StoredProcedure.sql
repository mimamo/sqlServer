USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_LotSerMst]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_LotSerMst]  @siteid varchar(10), @invtid varchar(30),@lotsernbr varchar(25), @whseloc varchar(10)  as      
select * from Lotsermst where 
siteid = @siteid 
and invtid = @invtid
and lotsernbr = @lotsernbr
and whseloc = @whseloc
order by siteid
GO
