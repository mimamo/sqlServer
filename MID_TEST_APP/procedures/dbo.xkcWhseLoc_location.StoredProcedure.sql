USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcWhseLoc_location]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcWhseLoc_location]  @siteid varchar(10), @whseloc varchar(10), @invtid varchar(30) as
select * from location where
siteid = @siteid
and whseloc = @whseloc
and invtid  = @invtid
order by siteid,whseloc
GO
