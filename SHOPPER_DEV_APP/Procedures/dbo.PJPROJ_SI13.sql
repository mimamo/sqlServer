USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_SI13]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_SI13] @parm1 varchar (10)  as
select * from PJPROJ
where manager1 = @parm1
and MSPInterface = 'Y'

order by project
GO
