USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_Spk2]    Script Date: 12/21/2015 16:07:14 ******/
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
