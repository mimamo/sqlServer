USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcInvLS_LotSerMst]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcInvLS_LotSerMst]  @invtid varchar(30),@lotsernbr varchar(25), @siteid varchar(10) , @whseloc varchar(10)  as      
select * from LotSerMst where 
invtid = @invtid
and lotsernbr = @lotsernbr
and  siteid = @siteid
and whseloc = @whseloc
order by invtid, lotsernbr
GO
