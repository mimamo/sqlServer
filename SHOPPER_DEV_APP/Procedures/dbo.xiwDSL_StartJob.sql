USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwDSL_StartJob]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:    <Author,,Delmer Johnson>
-- Create Date: <Modify Date,,6/11/2010>
-- Description  <Description,,SQL Agent Job can only be executed by owner or sysadmin so non-administrative SL users can't execute it.>
-- =============================================
CREATE PROC [dbo].[xiwDSL_StartJob]
@JobName sysname
WITH EXECUTE AS 'BELMAR\sltraps'
AS
	EXEC msdb.dbo.sp_start_job N'Traps Project Export'
GO
