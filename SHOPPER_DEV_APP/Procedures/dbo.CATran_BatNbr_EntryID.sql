USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_BatNbr_EntryID]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_BatNbr_EntryID    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CATran_BatNbr_EntryID] @parm1 varchar (10) as
select * from CATran
where batnbr = @parm1
order by entryid
GO
