USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_PJADDR_SALL]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[xCGS_PJADDR_SALL]  @parm1 varchar (2) , @parm2 varchar (48) , @parm3 varchar (2)   as
select * from xCGS_PJADDR
where    addr_key_cd = @parm1 and
DefaultType = @parm2 and
addr_type_cd like @parm3
order by addr_key_cd, DefaultType,
addr_type_cd
GO
