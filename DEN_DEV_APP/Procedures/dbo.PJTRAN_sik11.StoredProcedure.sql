USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_sik11]    Script Date: 12/21/2015 14:06:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_sik11] @parm1 varchar (16) , @parm2 varchar (6) , @parm3 smalldatetime   as
select * from PJTRAN
where
project = @parm1 and
fiscalNo = @parm2 and
trans_date <= @parm3 and
batch_type <> 'ALLC' and
alloc_flag  =  ' '
GO
