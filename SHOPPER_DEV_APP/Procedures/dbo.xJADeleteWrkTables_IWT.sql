USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xJADeleteWrkTables_IWT]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xJADeleteWrkTables_IWT] 
   @GUID                  varchar(255)
  
AS

BEGIN
  SET NOCOUNT ON

/******************************************************************************************************
*** SETUP TABLES ***
*******************************************************************************************************/

  DELETE FROM xjareportheaderwrk_iwt WHERE SessionGUID = @GUID
  DELETE FROM xjareportdetailwrk_iwt WHERE SessionGUID = @GUID
  DELETE FROM xjareportbillhistwrk_iwt WHERE SessionGUID = @GUID

END
GO
