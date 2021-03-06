USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAltara_pjrevhdr_spk2]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAltara_pjrevhdr_spk2] 
	@parm1 Varchar (16) 
AS
	select distinct PJREVHDR.* from PJREVHDR, PJPROJ where
 	pjrevhdr.project like @parm1 and pjrevhdr.project = pjproj.project
	--if Revision ID will always have 0000 then add the following line and to the pv
--	pjrevhdr.project = pjproj.project --and Revid = '0000'
	order by PJREVHDR.Project, PJREVHDR.revid
GO
