USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjsubcon_pwp]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.pjsubcon_pwp    Script Date: 06/7/06 ******/
Create Procedure [dbo].[pjsubcon_pwp] @parm1 varchar(16) as

SELECT *
  FROM PJSUBCON
 WHERE Subcontract like @parm1
 ORDER BY subcontract,project
GO
