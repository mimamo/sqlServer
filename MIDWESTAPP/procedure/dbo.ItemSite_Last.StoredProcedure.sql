USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_Last]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_Last    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[ItemSite_Last] @parm1 VarChar(10), @parm2 smalldatetime as
    update itemsite set selected = 1, countstatus = 'P'
    where siteid = @parm1
    and countstatus = 'A'
    and lastcountdate <= @parm2
GO
