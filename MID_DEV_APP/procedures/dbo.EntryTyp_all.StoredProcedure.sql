USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EntryTyp_all]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EntryTyp_all    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[EntryTyp_all] @parm1 varchar ( 2) as
    select * from Entrytyp
     where entryid like @parm1
    order by EntryId
GO
