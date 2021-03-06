USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRServCall_ContractId]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRServCall_ContractId] @parm1 varchar(15), @parm2 varchar(10),
                                  @parm3 varchar(10) as
        Select * from smContract
                where CustId = @parm1
                  and SiteId = @parm2
                  and ContractId like @parm3
                  and Status = 'A'
        Order by CustId,SiteId,ContractId
GO
