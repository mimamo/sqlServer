USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_Cycle]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_Cycle    Script Date: 4/17/98 10:58:18 AM ******/
Create Procedure [dbo].[ItemSite_Cycle] @parm1 varChar(10), @parm2 varchar(10) as
    update itemsite set selected = 1, countstatus = 'P'
    where siteid = @parm1
    and countstatus = 'A'
    and cycleid = @parm2
GO
