USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJGLSORT_SPK2]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJGLSORT_SPK2] as
Select * from PJGLSORT
order by  cpnyid, gl_acct, gl_subacct, project, pjt_entity
GO
