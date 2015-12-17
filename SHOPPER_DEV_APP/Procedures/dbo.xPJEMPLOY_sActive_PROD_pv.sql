USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJEMPLOY_sActive_PROD_pv]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xPJEMPLOY_sActive_PROD_pv](
@parm1 varchar(10)
)

AS

SELECT * FROM PJEMPLOY WHERE emp_status = 'A' AND employee like @parm1 AND emp_type_cd = 'PROD' ORDER BY employee
GO
