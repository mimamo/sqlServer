USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Note_All_by_TableName]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Note_All_by_TableName    Script Date: 4/17/98 12:50:25 PM ******/
create Proc [dbo].[Note_All_by_TableName] as
    select sTableName, nID from snote order by sTableName
GO
