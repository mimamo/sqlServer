USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sSYNC]    Script Date: 12/21/2015 16:01:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sSYNC] @parm1 varchar (16) as
select *
from PJPENT
where
MSPInterface = 'Y' and
project = @parm1
GO
