USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCODE_SPK2]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCODE_SPK2]  @parm1 varchar (4)   as
select * from PJCODE
where    code_type    =    @parm1
order by code_type,
code_value
GO
