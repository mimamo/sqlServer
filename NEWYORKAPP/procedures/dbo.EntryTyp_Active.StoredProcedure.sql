USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EntryTyp_Active]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EntryTyp_Active    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[EntryTyp_Active] @parm1 varchar ( 2) as
    select * from Entrytyp
     where entryid like @parm1
    and active =  1
    order by EntryId
GO
