USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJGLSORT_SPK2]    Script Date: 12/21/2015 14:34:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJGLSORT_SPK2] as
Select * from PJGLSORT
order by  cpnyid, gl_acct, gl_subacct, project, pjt_entity
GO
