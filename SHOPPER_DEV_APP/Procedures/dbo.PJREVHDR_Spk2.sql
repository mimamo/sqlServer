USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_Spk2]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVHDR_Spk2] @parm1 varchar (16) as
SELECT distinct * from PJREVHDR, PJPROJ
WHERE pjrevhdr.project like @parm1 and
pjrevhdr.project = pjproj.project
ORDER BY pjrevhdr.project
GO
