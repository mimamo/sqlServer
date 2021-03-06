USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJRTAB_sCuryid]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJRTAB_sCuryid]  @parm1 varchar (4)   as
select distinct(pjcode.data1) from pjrtab, pjcode
 where pjrtab.rate_table_id = @parm1 and
       pjcode.code_type = 'RATE' and
       pjrtab.rate_type_cd = pjcode.code_value and
       pjcode.data1 <> ' '
GO
