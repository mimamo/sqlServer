USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOPROJ_scont]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOPROJ_scont] @parm1 varchar (16)   as
	select	pjproj.contract, pjproj.project, pjcoproj.status1,
pjcoproj.amt_funded, pjcoproj.amt_pending
	from 	pjproj, pjcoproj
	where	pjproj.contract =  @parm1 and
	                pjproj.project = pjcoproj.project and
(pjcoproj.status1 = 'A' or pjcoproj.status1 = 'P')
GO
