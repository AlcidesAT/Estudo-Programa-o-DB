--Exemplo de Programação: SQL ou PLPGSQL

--Exemplo de uma função de soma em SQL
create or replace function soma(num1 integer, num2 integer)
returns integer as 'select num1 + num2;'  
language sql;

select soma(1,2);

---------------------------------------------------------

--Função de soma com sobrecarga e utilizando $$
create or replace function soma(num1 numeric, num2 numeric)
returns numeric
as $$ select num1 + num2; $$
language sql;

select soma (2.2, 3.3);
drop function soma(integer, integer);

create or replace function multiplica(num1 integer, num2 integer)
returns integer as $$ select $1 * $2; $$ --com parametros
language sql;

---------------------------------------------------------

--Reescrever a função some com PLPGSQL
create or replace function soma (num1 numeric, num2 numeric)
returns numeric as 
$$
begin 
	return num1 + num2;
end
$$
language plpgsql; --consigo usar laço de repetição, if else, for
select soma(2,5);

---------------------------------------------------------

create or replace function bemvindo (nome varchar(60))
returns void as 
$$
begin
	raise notice 'Bem Vindo: %', nome;--notificação pro console
end
$$
language plpgsql;
select bemvindo('Alcides');

---------------------------------------------------------

create or replace function meuhumor(humor int)
returns void as 
$$
begin 
	if (humor = 1) then
		raise notice 'Meu humor está bom hoje!';
	else
		raise exception 'Meu humor está péssimo!';
	end if; --sempre precisa fechar o banco, fazer um end if
end
$$
language plpgsql;
select meuhumor(1);

---------------------------------------------------------

create or replace function ePar(num integer)
returns varchar as 
$$
declare
	resultado varchar := ''; --cria-se uma variável vazia
begin 
	if (num %2 = 0) then
		resultado := 'É par';
	else
	resultado := 'É ímpar';
	end if;
	return resultado;
end
$$
language plpgsql;
select ePar(1);
select ePar(2);

---------------------------------------------------------

create or replace function diaDaSemana (data timestamp)
returns varchar as 
$$ 
declare 
	dia integer;
	resultado varchar;
begin
	dia := extract(dow from data); -- dow (day of week)
	case dia -- espécia de switch case
		when 0 then resultado := 'Domingo';
		when 1 then resultado := 'Segunda-Feira';
		when 2 then resultado := 'Terça-Feira';
		when 3 then resultado := 'Quarta-Feira';
		when 4 then resultado := 'Quinta-Feira';
		when 5 then resultado := 'Sexta-Feira';
		when 6 then resultado := 'Sábado';
	end case;
	return resultado;
end
$$
language plpgsql;

select diaDaSemana(current_date);  

---------------------------------------------------------

create or replace function mensagemnascimento(nome varchar, data date)
returns void as
$$
begin
	raise notice '%, voce nasceu no dia da semana: %',
	nome, diaDaSemana(data::timestamp);
end
$$
language plpgsql;

select mensagemnascimento('Alcides', '2004-07-10');

---------------------------------------------------------

create or replace function fazerLoop(data_inicial date, data_final date)
returns void as 
$$
declare 
	dias int;
begin 
	for dias in reverse (data_final - data_inicial)..0 loop --.. é intervalo, incremento
		raise notice '%', dias;
		perform pg_sleep(1);
	end loop;
end
$$
language plpgsql;

select fazerLoop (current_date, '2024-10-06'::date);

---------------------------------------------------------

create or replace function medianotas()
returns numeric as 
$$
declare
	soma numeric := 0; --qualquer valor sem inicialização é NULL
	conta numeric := 0;
	h historico%rowtype; --rowtype = equivalente a uma linha ou registro de uma tabela

begin
	for h in (select * from historico) loop
		conta := conta+1;
		soma := soma + h.vlrnot;
	end loop;
	return (soma / conta,2);
end
$$
language plpgsql;

select medianotas();

	
