USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_SPK23]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLABHDR_SPK23] @parm1 varchar (24) , @parm2 varchar (10) as
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
	   pjemploy.gl_subacct Like @parm1 and
	   pjlabhdr.cpnyid_home like @parm2
ORDER BY
	  pjlabhdr.employee ASC, pjlabhdr.pe_date DESC
GO
