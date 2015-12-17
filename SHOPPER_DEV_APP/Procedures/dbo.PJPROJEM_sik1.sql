USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_sik1]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_sik1] @parm1 varchar (10)  as
select pjprojem.*, pjproj.project_desc, pjproj.MSPInterface, pjproj.mspproj_id from pjprojem, pjproj
where  pjprojem.project = pjproj.project and
       pjprojem.employee like @parm1
order by pjprojem.project, pjprojem.employee
GO
