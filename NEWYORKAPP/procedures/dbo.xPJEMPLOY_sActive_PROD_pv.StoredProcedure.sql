USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xPJEMPLOY_sActive_PROD_pv]    Script Date: 12/21/2015 16:01:26 ******/
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
