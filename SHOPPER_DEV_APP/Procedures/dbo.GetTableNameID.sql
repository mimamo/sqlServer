USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GetTableNameID]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GetTableNameID    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.GetTableNameID    Script Date: 4/7/98 12:56:04 PM ******/
--SYSTEMTABLE
Create Proc  [dbo].[GetTableNameID] as
Select CONVERT(varchar(30),name), id from sysobjects where type = 'U' order by name
GO
