USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcWhseLoc_lotsermst]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcWhseLoc_lotsermst]  @siteid varchar(10), @whseloc varchar(10), @invtid varchar(30),@lotsernbr varchar (25) as
select * from lotsermst where
siteid = @siteid
and whseloc = @whseloc
and invtid  = @invtid
and lotsernbr = @lotsernbr
order by siteid,whseloc
GO
