USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Note_All_by_TableName]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Note_All_by_TableName    Script Date: 4/17/98 12:50:25 PM ******/
create Proc [dbo].[Note_All_by_TableName] as
    select sTableName, nID from snote order by sTableName
GO
