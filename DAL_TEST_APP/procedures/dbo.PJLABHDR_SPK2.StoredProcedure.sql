USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABHDR_SPK2]    Script Date: 12/21/2015 13:57:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLABHDR_SPK2] @parm1 varchar (10)  as
select * from PJLabhdr, pjemploy
where pjlabhdr.le_status =  'C' and
pjlabhdr.employee =  pjemploy.employee and
(pjemploy.manager1 = @parm1 or
pjemploy.manager2 = @parm1)
order by pjlabhdr.docnbr
GO
