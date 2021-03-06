USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_DocClasses_RefNbr_CpnyID]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_DocClasses_RefNbr_CpnyID] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar (10) as
    Select * from ARDoc where CpnyId = @parm1 and DocClass = 'P' and Custid = @parm2
                          and refnbr like @parm3 order by CpnyId, DocClass, RefNbr
GO
