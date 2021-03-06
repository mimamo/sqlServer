USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_SPK24]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLABHDR_SPK24]  as
	SELECT
	  PJLABHDR.docnbr,
	  PJLABHDR.employee,
	  PJEMPLOY.emp_name,
	  PJLABHDR.pe_date,
	  PJLABHDR.le_type,
	  PJLABHDR.le_status
		FROM
	  pjlabhdr,
	  pjemploy
	WHERE
		  pjlabhdr.le_status = 'C' and
	  pjlabhdr.employee =  pjemploy.employee
ORDER BY
	  pjlabhdr.docnbr
GO
