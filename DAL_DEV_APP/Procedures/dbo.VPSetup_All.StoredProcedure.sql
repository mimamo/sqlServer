USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[VPSetup_All]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[VPSetup_All] as
       Select * from VPSetup
GO
