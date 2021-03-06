USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x_DonovanAR_InsertRefNbr]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[x_DonovanAR_InsertRefNbr]

as

insert RefNbr
(Crtd_DateTime, Crtd_Prog, Crtd_User, DocType, LUpd_DateTime, LUpd_Prog, LUpd_User, RefNbr, S4Future01, S4Future02, S4Future03, S4Future04, S4Future05, S4Future06, S4Future07, S4Future08, S4Future09, S4Future10, S4Future11, S4Future12, User1, User2, User3, User4, User5, User6, User7, User8)
select
getdate(),
'IMPORT',
'IMPORT',
case when x.GrossAmount<0 then 'CM' else 'IN' end,
getdate(),
'IMPORT',
'IMPORT',
x.InvoiceNumber,
'',
'',
0,
0,
0,
0,
'1/1/1900',
'1/1/1900',
0,
0,
'',
'',
'',
'',
0,
0,
'',
'',
'1/1/1900',
'1/1/1900'
from x_DonovanAR_wrk x

--test for error
if @@error<>0
begin
print 'Error Inserting into RefNbr.'
return 1
end

return 0
GO
