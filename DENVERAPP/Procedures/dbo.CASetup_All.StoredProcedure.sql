USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CASetup_All]    Script Date: 12/21/2015 15:42:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CASetup_All    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CASetup_All]  as
       Select * from CASetup
GO
