USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sSYNC]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sSYNC] @parm1 varchar (16), @parm2 varchar (16) as
select * 
from PJPROJ 
where 
MSPInterface = 'Y' and
@parm1 <= project  and
@parm2 >= project
GO
