USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_invc]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_invc] @parm1 varchar(10) as
select * from pjinvhdr where invoice_num like @parm1
order by invoice_num
GO
