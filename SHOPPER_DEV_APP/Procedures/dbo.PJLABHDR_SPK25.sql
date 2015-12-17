USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_SPK25]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLABHDR_SPK25] @parm1 varchar (10)  as
	SELECT
	  PJLABHDR.docnbr,
	  PJLABHDR.employee,
	  PJEMPLOY.emp_name,
	  PJLABHDR.pe_date,
	  PJLABHDR.le_type,
	  PJLABHDR.le_status,
	  PJEMPLOY.manager1,
	  PJEMPLOY.manager2,
	  PJEMPLOY.gl_subacct,
	  PJLABHDR.le_id05,
          PJLABHDR.le_id07
	FROM
	  pjlabhdr,
	  pjemploy
		WHERE
	   pjlabhdr.employee =  pjemploy.employee and
	   (pjlabhdr.le_status = 'C' or pjlabhdr.le_status = 'A') and
	   pjlabhdr.cpnyid_home Like @parm1
ORDER BY
	  pjlabhdr.employee ASC, pjlabhdr.pe_date DESC
GO
